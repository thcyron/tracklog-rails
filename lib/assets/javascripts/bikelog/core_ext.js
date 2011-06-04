Number.prototype.round = function() {
  return Math.round(this);
}

Number.prototype.to_kilometers = function() {
  return this / 1000.0;
}

Number.prototype.to_feet = function() {
  return this / 0.3048;
}

Number.prototype.to_miles = function() {
  return this / 1609.344;
}

