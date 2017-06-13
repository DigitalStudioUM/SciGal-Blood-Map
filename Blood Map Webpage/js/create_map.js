//TODO
//Set marker to change colour of associated polygon on hover
//Figure out how best to stop style removal of selected polygon once mouseout occurs

var map;

var mapPolygons = [];
var mapMarkers = [];

var polygonStyleDeselected = {
    strokeColor: '#343030',
    strokeOpacity: 0.8,
    strokeWeight: 1,
    fillColor: '#d0d5dd',
    fillOpacity: 0.35
};

var polygonStyleSelected = {
    strokeWeight: 4.0,
    fillColor: '#bbd9b7'
}

var polygonStyleHover = {
    strokeColor: '#74c16a',
    fillColor: '#77af70',
    strokeWeight: 2
}

var bloodMarkersShowing = false;
var zoomLevelAbstraction = 6;

var zoomedOutImage = "images/reddot.jpg";

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

        var tribeName = "";

        if (jsonData.features[i].properties.Tribe) {
            tribeName = jsonData.features[i].properties.Tribe;
        } else {
            tribeName = jsonData.features[i].properties.TindaleTribe;
        }

        var AnImage = 'images/names/' + tribeName + '.png';
        var bloodImage = 'images/names_blood/' + tribeName + '-blood.png';


        //https://developers.google.com/maps/documentation/javascript/symbols
        var marker = new google.maps.Marker({
            position: {

                lat: center.x,
                lng: center.y

            },
            map: map,
            icon: AnImage,
            tribeIcon: AnImage,
            bloodIcon: bloodImage,
            title: jsonData.features[i].properties.Tribe,
            Tribe: tribeName,
            Speaker: jsonData.features[i].properties.Speaker,
            Audio: jsonData.features[i].properties.Audio,
            Blood: jsonData.features[i].properties.Blood
        });

        marker.addListener('click', function () {
            markerSelected(this);
        });

        mapMarkers.push(marker);

        //console.log('x: ' + center.x + ' y: ' + center.y);


        var newPoly = new google.maps.Polygon({

            paths: someCoords,
            tribe: tribeName,
            selected: false

        });
        newPoly.setOptions(polygonStyleDeselected);

        google.maps.event.addListener(newPoly, 'click', function (event) {
            polygonSelected(this);
        });

        google.maps.event.addListener(newPoly, 'mouseover', function (event) {
            if (!this.selected) {
                this.setOptions(polygonStyleHover);
            }
        });

        google.maps.event.addListener(newPoly, 'mouseout', function (event) {
            if (!this.selected) {
                this.setOptions(polygonStyleDeselected);
            }
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

    map.addListener('zoom_changed', function () {
        //        console.log(map.getZoom());
        if (map.getZoom() < zoomLevelAbstraction) {
            mapMarkers.forEach(function (m) {
                m.setIcon(zoomedOutImage);
            })
        } else {
            updateBloodMarkers();
        }
    });
}

function updateInfoPanel(marker) {
    var htmlString = "";

    htmlString = "Tribe: " + marker.Tribe + "<br />";

    htmlString = htmlString + "Phonemicised word for blood: " + marker.Blood + "<br />";

    if (marker.Speaker) {
        htmlString = htmlString + "Speaker: " + marker.Speaker + "</br>";

    }

    if (marker.Audio) {
        htmlString = htmlString + "<audio controls><source src='audio/" + marker.Audio + "' type='audio/ogg'>Your browser does not support the audio element.</audio></br>";

    }

    //htmlString = htmlString + "En-us-Galicia-2.ogg";

    document.getElementById("more_detail_div").innerHTML = htmlString;
}


function polygonSelected(poly) {
    poly.selected = true; //Set selected marker to true

    //Get associated marker based on tribe of polygon
    var markerOfTribe = mapMarkers.filter(v => v.Tribe === poly.tribe);
    //Call updateInfo to update information panel with appriate sources
    updateInfoPanel(markerOfTribe[0]);

    //Set all polygons to deseleted style
    mapPolygons.forEach(function (poly) {
        poly.setOptions(polygonStyleDeselected);
    });
    //Set this polygon to selected style
    poly.setOptions(polygonStyleSelected);
}

function markerSelected(marker) {
    var polygonOfTribe = mapPolygons.filter(v => v.tribe == marker.Tribe);
    polygonSelected(polygonOfTribe[0]);
    updateInfoPanel(marker);
}

function updateBloodMarkers() {
    mapMarkers.forEach(function (m) {
        if (map.getZoom() < zoomLevelAbstraction) {
            m.setIcon(zoomedOutImage);
        } else {

            if (bloodMarkersShowing) {
                m.setIcon(m.bloodIcon);
            } else {

                m.setIcon(m.tribeIcon);
            }
        }
    });

}
