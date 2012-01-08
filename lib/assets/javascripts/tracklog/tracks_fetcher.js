Tracklog.TracksFetcher = function(url, callback) {
  this.url           = url;
  this.callback      = callback;
  this.tracks        = [];
  this.reducedTracks = [];

  this.fetchTracks();
};

Tracklog.TracksFetcher.prototype.fetchTracks = function() {
  var that = this;

  $.getJSON(this.url, function(tracks) {
    tracks.forEach(function(track) {
      that.processTrack(track);
    });

    that.callback(that);
  });
};

Tracklog.TracksFetcher.prototype.processTrack = function(track) {
  var segments = this.getSegments(track),
      reducedTrack = this.reduceTrack(track),
      reducedSegments = this.getSegments(reducedTrack);

  this.tracks.push({
    name: track.name,
    segments: segments
  });

  this.reducedTracks.push({
    name: track.name,
    segments: reducedSegments
  });
};

Tracklog.TracksFetcher.prototype.reduceTrack = function(track) {
  return track; // TODO
};

Tracklog.TracksFetcher.prototype.getSegments = function(track) {
  var segments = [];

  for (var i = 0; i < track.points.length - 1; i++) {
    var p1 = track.points[i],
        p2 = track.points[i + 1],
        duration, distance, speed, ascent;

    ascent   = p2.elevation - p1.elevation;
    duration = p2.timestamp - p1.timestamp;
    distance = Tracklog.haversine(p1, p2);

    if (duration != 0) {
      speed = distance / duration;
    }

    p1.latlng = new google.maps.LatLng(p1.latitude, p1.longitude);
    p2.latlng = new google.maps.LatLng(p2.latitude, p2.longitude);

    segments.push({
      start: p1,
      end: p2,
      duration: duration,
      distance: distance,
      speed: speed,
      ascent: ascent
    });
  }

  return segments;
};
