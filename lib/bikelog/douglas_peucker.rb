module Bikelog
  # This class implements the Douglas Peucker algorithm.
  # See http://en.wikipedia.org/wiki/Ramer-Douglas-Peucker_algorithm
  class DouglasPeucker
    def self.reduce(points, epsilon)
      return points if points.size <= 2

      m = (points.last[1].to_f - points.first[1].to_f) / (points.last[0].to_f - points.first[0].to_f)
      t = points.first[1] - m * points.first[0]

      dmax = -1
      index = -1

      1.upto(points.size - 2) do |i|
        d = distance(points[i][0], points[i][1], m, t)

        if d > dmax
          dmax = d
          index = i
        end
      end

      if dmax >= epsilon
        res1 = reduce(points[0..index], epsilon)
        res2 = reduce(points[index..-1], epsilon)

        res1 + res2[1..-1]
      else
        [points.first, points.last]
      end
    end

    # Calculate the orthogonal distance of the point (x,y) to the
    # line given as y = mx + t.    
    def self.distance(x, y, m, t)
      dt = (t - y + m * x).abs
      phi = 0.5 * Math::PI - Math.atan(m * Math::PI / 180)
      Math.sin(phi) * dt
    end
  end
end

if $0 == __FILE__
  p Bikelog::DouglasPeucker.reduce([[0,4],[2,1],[5,2],[7,4],[9,4],[11,2],[14,0],[16,4]], 1.0)
end
