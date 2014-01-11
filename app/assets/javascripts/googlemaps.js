var map, marker, current_pos, initial_pos = new google.maps.LatLng(49.2649, -123.2351);

function updatePositionDisplay( latlng ) // updates the readout under the map with the supplied position
{
    document.getElementById('event_latitude').value  = latlng.lat();
    document.getElementById('event_longitude').value = latlng.lng();
}

function initializemap()
{
    var mapOptions = { zoom: 14, center: initial_pos, mapTypeId: google.maps.MapTypeId.ROADMAP };
    if (document.getElementById('events_map'))
	{ alert( 'There is a map')}
    else {alert('There is no map')}
    map = new google.maps.Map(document.getElementById('events_map'), mapOptions);
    if (map != null) {alert('Map object has been created')}

    updatePositionDisplay( initial_pos );
}

google.maps.event.addDomListener(window, 'load', initializemap);
