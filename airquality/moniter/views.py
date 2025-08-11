from django.shortcuts import render # type: ignore
import requests # type: ignore
import numpy as np # type: ignore
from sklearn.linear_model import LinearRegression # type: ignore
from django.shortcuts import render # type: ignore
from django.http import JsonResponse # type: ignore

def dashboard(request):
    return render(request, 'dashboard.html')

def get_air_data(request):
    # Fetch latest 50 readings from ThingSpeak
    url = "https://api.thingspeak.com/channels/YOUR_CHANNEL_ID/feeds.json?results=50"
    data = requests.get(url).json()
    feeds = data['feeds']
    times = [f['created_at'] for f in feeds if f['field1']]
    values = [float(f['field1']) for f in feeds if f['field1']]

    # Prediction using Linear Regression
    X = np.arange(len(values)).reshape(-1, 1)
    y = np.array(values)
    model = LinearRegression()
    model.fit(X, y)

    future_steps = 5
    future_X = np.arange(len(values), len(values) + future_steps).reshape(-1, 1)
    predicted_values = model.predict(future_X)
    predicted_times = [f"Pred {i+1}" for i in range(future_steps)]

    return JsonResponse({
        'times': times,
        'values': values,
        'pred_times': predicted_times,
        'pred_values': predicted_values.tolist()
    })


# Create your views here.
