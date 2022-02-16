import json
import requests
import numpy as np

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
                coords = np.array((1,2))
                common_names, lat, lon = data['commonName'], data['lat'], data['lon'] 
                self.points[common_names] = (lat, lon)
            print(datas[0].keys())
            print(datas[0]['id'])
        except requests.ConnectionError:
           print("i fucked up") 

  ##  class _MyAppState extends State<MyApp> {
  ##var _postJson = [];
  ##final url = "https://api.tfl.gov.uk/BikePoint/";
  ##void fetchPosts() async {
  ##  try {
  ##    final response = await get(Uri.parse(url));
  ##    final jsonData = jsonDecode(response.body) as List;
##      
  ##    setState(() {
  ##      _postJson = jsonData;
  ##    });
  ##  } catch (err) {}
  ##}
##
  ##@override
  ##void initState() {
  ##  super.initState();
  ##  fetchPosts();
  ##}
##
  ##@override
  ##Widget build(BuildContext context) {
  ##  //fetchPosts();
  ##  return MaterialApp(
  ##    home: Scaffold(
  ##      body: ListView.builder(
  ##          itemCount: _postJson.length,
  ##          itemBuilder: (context, i) {
  ##            final post = _postJson[i];
  ##            return Text("Street name: ${post["commonName"]}\n lat: ${post["lat"]}\n lon: ${post["lon"]}\n\n");
  ##          }),
  ##    ),
  ##  );
  ##}
    pass

class BikeDataProcessor:
    
    @staticmethod
    def calculate_distance(coord_1, coord_2):
        pass
       # distance = coord_1[0] -
    
    
    @staticmethod
    def filter_based_on_distance(distance, data):
        pass    
    
    pass

if __name__ == "__main__":
    b = BikeDataPull()
    b.pull_data()