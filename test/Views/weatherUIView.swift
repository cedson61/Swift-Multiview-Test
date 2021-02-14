//
//  weatherUIView.swift
//  test
//
//  Created by Chase Edson on 12/5/20.
//

import SwiftUI
import WebKit
import CoreLocation

//parse the json!!



//with new method, this "struct" bullshit is completely obselete :)
/*
 struct weatherInfo: Codable {
    
    let name: String
    //let currentTemp: String
    let main: [String]
    //let feelsTemp: Int
    //let maxTemp: Int
    //let minTemp: Int
    //let description: String
    
    init(json: [String: Any]) {
        name = json["name"] as? String ?? ""
        main = json["main"] as? [String] ?? ["undefined"]
        //currentTemp = main["temp"] as? String ?? ""
        
    }
     
}
*/


extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}




struct weatherUIView: View {
//openweather api key = '9385f941bbcca27c4d8298e6dcffa4a2'
    @State var isLoaded = false
    @State var weatherName: String = ""
    @State var weatherDescription: String = ""
    @State var weatherTemp: Decimal = 0
    @State var weatherFeelsTemp: Decimal = 0
    @State var weatherPressure: Decimal = 0
    @State var weatherHumidity: Decimal = 0
    @State var weatherWindDirection: String = ""
    @State var weatherWindSpeed: Decimal = 0
    
    //cities to demo the picker functionality
    var cities = ["Sammamish", "Seattle", "Los Angeles", "Austin", "Renton"]
    @State private var selectedFrameworkIndex = 0




    
    var body: some View {
        VStack {
            Text(weatherName)
                .onAppear(perform: loadData)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Text(weatherDescription)
                .font(Font.title.weight(.light))
            
            Spacer()
                    .frame(height: 50)
            
            VStack {
                HStack {
                    Text("Temperature: ")
                    Text(NSDecimalNumber(decimal: weatherTemp).stringValue)
                    Text("F")
                        .font(Font.title.weight(.light))
                        
                }
            
                HStack {
                    Text("Feels Like: ")
                    Text(NSDecimalNumber(decimal: weatherFeelsTemp).stringValue)
                    Text("F")
                        .font(Font.title.weight(.light))
                    
                }
                HStack {
                    Text("Air Pressure: ")
                    Text(NSDecimalNumber(decimal: weatherPressure).stringValue)
                    Text("hPa")
                        .font(Font.title.weight(.light))
                
                }
                HStack {
                    Text("Air Humidity: ")
                    Text(NSDecimalNumber(decimal: weatherHumidity).stringValue)
                    Text("%")
                        .font(Font.title.weight(.light))
                
                }
                Text("Wind Speed: ")
                HStack {
                    
                    Text(NSDecimalNumber(decimal: weatherWindSpeed).stringValue)
                    Text("mph " + weatherWindDirection)
                        .font(Font.title.weight(.light))
                        
                
                }
                
            }
            VStack {
                    Picker(selection: $selectedFrameworkIndex, label: Text("")) {
                        ForEach(0 ..< cities.count) {
                           Text(self.cities[$0])
                        }
                     }.onChange(of: selectedFrameworkIndex, perform: { (value) in
                        loadData()
                    })
                     Text("Selected City: \(cities[selectedFrameworkIndex])")
                        .font(Font.title.weight(.light))
                  }.padding()
        }
            .font(.title)
            .multilineTextAlignment(.center)
            
        
        .padding(50)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .isHidden(!isLoaded)
        //.animation(.easeInOut(duration: 0.25))
        .animation(.spring())

        
        
        
            

            
    }
    
    
    
    //load data into variables listing the view
    //this is total shit i know <3
    
    
    func loadData() {
        
        let selectedCity = self.cities[selectedFrameworkIndex].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let jsonUrlString = "https://api.openweathermap.org/data/2.5/weather?q=" + selectedCity + "&appid=9385f941bbcca27c4d8298e6dcffa4a2"
        print("Requesting URL: " + jsonUrlString)
        
        guard let url = URL(string: jsonUrlString) else{
            print("Invalid Request URL")
            return
            
        }
        
        
        

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {data, response, error in
            //json loaded as 'data' now decode that shit
            guard let data = data else { return }
            //let dataAsString = String(data: data, encoding: .utf8)
            //print (dataAsString!)
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print (json)
                //data desired:
                //temperature
                //feels like
                //air pressure
                //air humidity
                //description
                //wind direction
                //wind speed
                let rootDict = json as! [String:Any]
                let main = rootDict["main"] as! [String:Any]
                let info = rootDict["weather"] as! NSArray
                let weatherinfo = info[0] as! [String:Any]
                let wind = rootDict["wind"] as! [String:Any]
                let temperature = main["temp"] as! NSNumber
                let feelstemperature = main["feels_like"] as! NSNumber
                let pressure = main["pressure"] as! NSNumber
                let humidity = main["humidity"] as! NSNumber
                let directdeg = wind["deg"] as! NSNumber
                let windspeed = wind["speed"] as! NSNumber
                
                weatherName = rootDict["name"] as! String
                weatherName = "Weather in " + weatherName
                weatherDescription = weatherinfo["description"] as! String
                let decimalTemp = temperature.decimalValue
                weatherTemp = (9.0 / 5.0) * (decimalTemp - 273.0) + 32.0
                let decimalFeelsTemp = feelstemperature.decimalValue
                weatherFeelsTemp = (9.0 / 5.0) * (decimalFeelsTemp - 273.0) + 32.0
                let decimalPressure = pressure.decimalValue
                weatherPressure = decimalPressure
                let decimalHumidity = humidity.decimalValue
                weatherHumidity = decimalHumidity
                let decimalSpeed = windspeed.decimalValue
                weatherWindSpeed = decimalSpeed * 2.23
                let decimalDirection = directdeg.decimalValue
                
                func displayCardinalDirection(deg: Decimal) -> String {
                    
                    if (deg >= 0 && deg < 22.5){
                        return "north"
                    } else if (deg >= 22.5 && deg < 67.5){
                        return "northeast"
                    } else if (deg >= 67.5 && deg < 112.5){
                        return "east"
                    } else if (deg >= 112.5 && deg < 157.5){
                        return "southeast"
                    } else if (deg >= 157.5 && deg < 202.5){
                        return "south"
                    } else if (deg >= 202.5 && deg < 247.5){
                        return "southwest"
                    } else if (deg >= 247.5 && deg < 292.5){
                        return "west"
                    } else if (deg >= 292.5 && deg < 337.5){
                        return "northwest"
                    } else if (deg >= 337.5 && deg < 360){
                        return "north"
                    } else {
                        return "shit's broke"
                    }
                }
                
                weatherWindDirection = displayCardinalDirection(deg: decimalDirection)
                isLoaded = true
                
                
                
                

            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }

            
            
        }.resume()
           
    }
    
}



struct weatherUIView_Previews: PreviewProvider {
    static var previews: some View {
        weatherUIView()
    }
}
