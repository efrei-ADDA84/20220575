import requests
from requests.exceptions import RequestException
import os
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def get_weather_by_lat_lon():
    api_endpoint = 'https://api.openweathermap.org/data/2.5/weather'
    lat = request.args.get('lat')
    lon = request.args.get('lon')
    api_key = os.getenv('API_KEY')
    try:
        params = {'lat': lat,
                  'lon': lon,
                  'appid': api_key}
        response = requests.get(url=api_endpoint, params=params)
        data = response.json()
        return jsonify(data)
    except RequestException as exception:
        return str(exception)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8081)