Future = require('fibers/future');
_ = require "underscore"

exports.futuresWrapAsync = (fn, context)->
  future = new Future();
  console.log _.functions future
  return (args...)->
    args.push (err, result)->
      if err
        future.throw err
      else
        future.return result
    fn.apply context, args
    future.wait()
