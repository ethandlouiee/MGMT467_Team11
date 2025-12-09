import functions_framework
import json
import requests
import os
import datetime
from google.cloud import pubsub_v1

# Initialize Pub/Sub Publisher
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = os.environ.get("GCP_PROJECT")
TOPIC_ID = "openaq-topic"

# Build the topic path
# Note: In some environments, if TOPIC_ID is not set, this might fail, 
# so we default to the known topic name if the env var is missing.
if not TOPIC_ID:
    TOPIC_ID = "openaq-topic"

topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)

@functions_framework.http
def fetch_openaq(request):
    """
    Fetches live Air Quality data for Rome, Italy from Open-Meteo.
    Triggered by HTTP request (Cloud Scheduler).
    """
    # Open-Meteo Air Quality API (Free, No Key Required)
    url = "https://air-quality-api.open-meteo.com/v1/air-quality"
    
    # Coordinates for Rome, Italy
    params = {
        "latitude": 41.9028,
        "longitude": 12.4964,
        "current": "carbon_monoxide,nitrogen_dioxide,ozone",
        "timezone": "Europe/Rome"
    }
    
    try:
        response = requests.get(url, params=params)
        if response.status_code != 200:
            return f"API Error: {response.status_code}", 500
            
        data = response.json()
        current = data.get("current", {})
        current_units = data.get("current_units", {})
        
        # Map Open-Meteo parameter names to our BigQuery schema names
        mapping = {
            "carbon_monoxide": "co",
            "nitrogen_dioxide": "no2",
            "ozone": "o3"
        }
        
        count = 0
        
        # Loop through the 3 gases we requested
        for api_name, standard_name in mapping.items():
            val = current.get(api_name)
            unit = current_units.get(api_name, "unknown")
            
            if val is not None:
                payload = {
                    # Add seconds (:00) to ensure BigQuery recognizes it as a valid TIMESTAMP
                    "timestamp": f"{current.get('time')}:00", 
                    "city": "Rome",
                    "parameter": standard_name,
                    "value": float(val),
                    "unit": unit
                }
                
                # Convert to JSON and Publish to Pub/Sub
                data_str = json.dumps(payload)
                publisher.publish(topic_path, data_str.encode("utf-8"))
                count += 1
                
        return f"Success: Published {count} live readings from Rome to {TOPIC_ID}.", 200
        
    except Exception as e:
        return f"Error: {str(e)}", 500
