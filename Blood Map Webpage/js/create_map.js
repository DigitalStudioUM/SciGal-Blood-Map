var map;

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






        map.data.add({
            geometry: new google.maps.Data.Polygon([someCoords])
        });

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

        event.feature.setProperty('isColorful', true);

    });

    // When the user hovers, tempt them to click by outlining the letters.
    // Call revertStyle() to remove all overrides. This will use the style rules
    // defined in the function passed to setStyle()
    map.data.addListener('mouseover', function (event) {
        map.data.revertStyle();
        map.data.overrideStyle(event.feature, {
            strokeWeight: 8
        });
    });

    map.data.addListener('mouseout', function (event) {
        map.data.revertStyle();
    });
}