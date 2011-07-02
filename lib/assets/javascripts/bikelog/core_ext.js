Number.prototype.round = function(precision) {
  var factor = Math.pow(10, precision || 0);
  return Math.round(this * factor) / factor;
}

Number.prototype.to_kilometers = function() {
  return this / 1000.0;
}

Number.prototype.to_kilometers_per_hour = function() {
  return this / 1000.0 * 3600.0;
}

Number.prototype.to_feet = function() {
  return this / 0.3048;
}

Number.prototype.to_miles = function() {
  return this / 1609.344;
}

Number.prototype.to_miles_per_hour = function() {
  return this / 1609.344 * 3600.0;
}
