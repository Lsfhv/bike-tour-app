class Node:
    
    #used to represent end of streets
    def __init__(self, name, lat, lon):
        self.name = name
        self.lat = lat
        self.lon = lon
    
class Edge:
    
    def __init__(self, node_i, node_j):
        self.node1 = node_i
        self.node2 = node_j
    
class MapGraph:
    
    def 
        