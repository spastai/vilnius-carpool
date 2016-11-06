assert = require('assert')
sinon = require('sinon')

{MapAdapter} = require "../../server/MapAdapter.coffee"
{decodePoints} = require "../../server/encoder.coffee"
{futuresWrapAsync} = require "./async.coffee"

d = console.log.bind console

maps = new MapAdapter({});

# Stubs
global.Meteor =
  wrapAsync: futuresWrapAsync
# sinon.stub(Meteor,"wrapAsync", futuresWrapAsync);

describe "Service logic", ->
  describe '#isLocationOnEdge', ->
    path = decodePoints "ggulIqkgyCDf@JHR@@jANjDd@fHLlAt@pHuKdCiB`@aDx@gGdB{IxByD`AoBlAWRsCbBkCxA}@^cBZo@VyAPaADkETM?GEOMo@eAmIuLSQWOe@KaFiAsA_@]Q_Ao@u@k@{B{AcCwAmAw@qByAqAfCgCtF{ApCq@vAQrAkA~JGVObAGROXMTe@CyBCcDL_DJC?c@DEGKKc@?s@K{@MmAA]EUGQMc@g@OSKe@M}@?_ADy@f@yJUIqCeAm@Y[Q]a@Ye@`AyCx@cF|AkK`@gC\\mBrAwFpB_InBiH}Bc@}A[m@~Ba@xA"

    it 'point on line', ->
      # point = [54.6818, 25.2655];
      point = [ 54.6724, 25.27283 ];
      assert.ok maps.isLocationOnEdge(point, path)

    it 'point near line', ->
      point = [54.6818, 25.2655];
      assert.ok maps.isLocationOnEdge(point, path)

    it 'point 180m away', ->
      point = [54.682341, 25.262173]
      assert.ok maps.isLocationOnEdge(point, path, 360)

    it 'point 180m away, with smaller distance', ->
      point = [54.682341, 25.262173]
      assert.ok not maps.isLocationOnEdge(point, path, 300)

  describe '#getTripPath', ->
    trip =
      role: "driver",
      fromLoc: [25.27430490000006, 54.672818],
      toLoc: [25.27726899999993, 54.69814],
    stops = [
      _id: "LHQK9tSeXe5nJasAT",
      title: "Ciurlionio",
      loc: [25.2655, 54.6818]
    ]
    maps.getTripPath trip, stops