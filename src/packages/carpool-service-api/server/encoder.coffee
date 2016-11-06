exports.encodePoints = (coords) ->
  i = 0
  plat = 0
  plng = 0
  encoded_points = ""
  i = 0
  while i < coords.length
    lat = coords[i][0]
    lng = coords[i][1]
    encoded_points += encodePoint(plat, plng, lat, lng)
    plat = lat
    plng = lng
    ++i
  # do not close polyline
  #encoded_points += encodePoint(plat, plng, coords[0][0], coords[0][1]);
  encoded_points

exports.decodePoints = (encoded) ->
  # array that holds the points
  points = []
  index = 0
  len = encoded.length
  lat = 0
  lng = 0
  while index < len
    b = undefined
    shift = 0
    result = 0
    loop
      b = encoded.charAt(index++).charCodeAt(0) - 63 #finds ascii and substract it by 63
      result |= (b & 0x1f) << shift
      shift += 5
      break unless b >= 0x20
    dlat = ((if (result & 1) isnt 0 then ~(result >> 1) else (result >> 1)))
    lat += dlat
    shift = 0
    result = 0
    loop
      b = encoded.charAt(index++).charCodeAt(0) - 63
      result |= (b & 0x1f) << shift
      shift += 5
      break unless b >= 0x20
    dlng = ((if (result & 1) isnt 0 then ~(result >> 1) else (result >> 1)))
    lng += dlng
    points.push [
      lat / 1e5
      lng / 1e5
    ]
  points

encodeSignedNumber = (num) ->
  sgn_num = num << 1
  sgn_num = ~(sgn_num)  if num < 0
  encodeNumber sgn_num
encodeNumber = (num) ->
  encodeString = ""
  while num >= 0x20
    encodeString += (String.fromCharCode((0x20 | (num & 0x1f)) + 63))
    num >>= 5
  encodeString += (String.fromCharCode(num + 63))
  encodeString
encodePoint = (plat, plng, lat, lng) ->
  late5 = Math.round(lat * 1e5)
  plate5 = Math.round(plat * 1e5)
  lnge5 = Math.round(lng * 1e5)
  plnge5 = Math.round(plng * 1e5)
  dlng = lnge5 - plnge5
  dlat = late5 - plate5
  encodeSignedNumber(dlat) + encodeSignedNumber(dlng)
