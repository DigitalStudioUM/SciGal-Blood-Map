var map;

var mapPolygons = [];
var mapMarkers = [];

function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 5,
        center: {
            lat: -28,
            lng: 137
        }
    });

    // Load GeoJSON.
    //map.data.loadGeoJson('https://storage.googleapis.com/mapsdevsite/json/google.json');

    //map.data.addGeoJson(jsonData);



    //console.log(jsonData);

    var i = 0;
    var j = 0;
    var someCoords = [];
    var hackHack = [];

    for (i = 0; i < jsonData.features.length; i++) {
        //console.log(jsonData.features[i]);

        //console.log(jsonData.features[i].properties.Source);
        //console.log(jsonData.features[i].properties.Tribe);

        //console.log(jsonData.features[i].geometry.coordinates[0][0].length);

        for (j = 0; j < jsonData.features[i].geometry.coordinates[0][0].length; j++) {
            //console.log(jsonData.features[i].geometry.coordinates[0][0][j][0]);//lat?
            //console.log(jsonData.features[i].geometry.coordinates[0][0][j][1]);//long


            /*
            	Note: GEOJSON annoyingly does long lat... rather than lat long. 
            		Keep this in mind to avoid nasty surprises!
            */
            someCoords.push({

                lat: jsonData.features[i].geometry.coordinates[0][0][j][1],
                lng: jsonData.features[i].geometry.coordinates[0][0][j][0]

            });

            hackHack.push({

                x: jsonData.features[i].geometry.coordinates[0][0][j][1],
                y: jsonData.features[i].geometry.coordinates[0][0][j][0]

            });

        }
        //console.log(someCoords);

        var con = new Contour(hackHack);
        center = con.centroid();


        /*
			
        	Drop a marker at the centre of each polygon
			
        */


        /*
			
        	This is the the image for this marker. 
        	So this is where we have png images of each of the tribe names
        	
        	var anImage = 'images/' + jsonData.features[i].properties.Tribe + '.png';
        */

        var AnImage = 'images/names/' + jsonData.features[i].properties.Tribe + '.png';


        //https://developers.google.com/maps/documentation/javascript/symbols
        var marker = new google.maps.Marker({
            position: {

                lat: center.x,
                lng: center.y

            },
            map: map,
            icon: AnImage,
            title: jsonData.features[i].properties.Tribe,
            Tribe: jsonData.features[i].properties.Tribe,
            Speaker: jsonData.features[i].properties.Speaker,
            Audio: jsonData.features[i].properties.Audio,
            Blood: jsonData.features[i].properties.Blood
        });

        marker.addListener('click', function () {
            console.log(this.Tribe);

            setSelected(this.Tribe);

            var htmlString = "";

            htmlString = "Tribe: " + this.Tribe + "<br />";

            htmlString = htmlString + "Phonemicised word for blood: " + this.Blood + "<br />";

            if (this.Speaker) {
                htmlString = htmlString + "Speaker: " + this.Speaker + "</br>";

            }

            if (this.Audio) {
                htmlString = htmlString + "<audio controls><source src='audio/" + this.Audio + "' type='audio/ogg'>Your browser does not support the audio element.</audio></br>";

            }

            //htmlString = htmlString + "En-us-Galicia-2.ogg";

            document.getElementById("more_detail_div").innerHTML = htmlString;

        });


        //console.log('x: ' + center.x + ' y: ' + center.y);


        var newPoly = new google.maps.Polygon({

            paths: someCoords,
            tribe: jsonData.features[i].properties.Tribe,
            strokeColor: '#343030',
            strokeOpacity: 0.8,
            strokeWeight: 1,
            fillColor: '#d0d5dd',
            fillOpacity: 0.35

        })

        google.maps.event.addListener(newPoly, 'click', function (event) {
            setSelected(this.tribe);
            console.log(event);
            var p = mapPolygons.filter(v => v.tribe === this.tribe);
            console.log(p);
            p.strokeWeight = 8;
            p.fillColor = '#bbd9b7';
        });

        mapPolygons.push(newPoly);

        newPoly.setMap(map);
        
        //reset
        someCoords = [];
        hackHack = [];

    }

    // Color each letter gray. Change the color when the isColorful property
    // is set to true.
    map.data.setStyle(function (feature) {
        var color = 'gray';
        if (feature.getProperty('isColorful')) {
            color = feature.getProperty('color');
        }
        return /** @type {google.maps.Data.StyleOptions} */ ({
            fillColor: color,
            strokeColor: color,
            strokeWeight: 2
        });
    });

    // When the user clicks, set 'isColorful', changing the color of the polygons.
    map.data.addListener('click', function (event) {
        console.log(this.tribe);
        map.data.revertStyle();
        map.data.overrideStyle(event.feature, {
            fillColor: "#ff0000"
        });
        //event.feature.setProperty('isColorful', true);

    });

    // When the user hovers, tempt them to click by outlining the letters.
    // Call revertStyle() to remove all overrides. This will use the style rules
    // defined in the function passed to setStyle()
    map.data.addListener('mouseover', function (event) {
        //map.data.revertStyle();
        map.data.overrideStyle(event.feature, {
            strokeWeight: 8
        });
    });

    map.data.addListener('mouseout', function (event) {
        //map.data.revertStyle();
        map.data.overrideStyle(event.feature, {
            strokeWeight: 1
        });
    });
}

function setSelected(tribeName) {
    console.log("In Set Selected");
}
