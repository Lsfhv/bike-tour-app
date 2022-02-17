import json
import requests
import googlemaps

class BikeDataPull:
    def __init__(self, url = "https://api.tfl.gov.uk/BikePoint/" , points = None):
        self.url = url
        if not points:
            points = {}
        self.points = points
        
    
    def pull_data(self):
        try:
            response = requests.get(self.url)
            datas =  json.loads(response.text)
            for data in datas:
                common_names, lat, lon = data['commonName'], data['lat'], data['lon'] 
                self.points[common_names] = (lat, lon)
        except requests.ConnectionError:
           print("error") 


class BikeDataProcessor:
    limit = 500
    client = googlemaps.Client(key="AIzaSyDN4RDUVv8lX81W1CeoqKVIAObUdAA0mQI")
    #parameters are coordinates
    @staticmethod
    def calculate_distance(origin, destination):
        try:
            response = BikeDataProcessor.client.distance_matrix(origin,destination, mode='walking', units = "metric", avoid = 'highways')
            dist = response['rows'][0]['elements'][0]['distance']['value']
            return dist
            #data = json.load(response)
            #distance = data['rows']['elements']['distance']
            #return distance
        except googlemaps.exceptions.ApiError :
            print("error with API key")
    
    
    @staticmethod
    def filter_based_on_distance(origin,limit, data):
        points_within_range = list()
        for d in data.keys():
            destination = data[d]
            if(BikeDataProcessor.calculate_distance(origin,destination) > limit):
                points_within_range.append(destination)
        return destination

if __name__ == "__main__":
    b = BikeDataPull()
    b.pull_data()
    curr_coord = (51.5044584,-0.105681) #test
    #destination = b.points['Tanner Street, Bermondsey']
    #destination = (51.5007,0.0858)
    #a = BikeDataProcessor.calculate_distance(curr_coord,destination)
    #print(a)
    list = BikeDataProcessor.filter_based_on_distance(curr_coord,500,b.points)
    print(list)