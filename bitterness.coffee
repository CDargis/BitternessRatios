# (G - 1) * 1000)
gravityPoints = (g) ->
  (g - 1) * 1000

# IBU / OG points
originalBitternessRatio = (bu, og) ->
  bu / gravityPoints(og)

# RBR = (BU:GU) * (1 + (ADF - 0.7655))
relativeBitternessRatio = (bitternessRatio, og, fg) ->

  # ADF (apparent attenuation) = (starting gravity - current gravity) / (starting gravity - 1)
  aparentAttentuationRate = (og, fg) ->
    (og - fg) / (og - 1)

  (bitternessRatio) * (1 + (aparentAttentuationRate(og, fg) - 0.7655))

# IBU / (0.1808 * plato(og)) + (0.8192) + plato(fg) )
bitternessUnitsToRelativeRatio = (bu, og, fg) ->
  plato = (gp) ->
    gp / 4

  bu / ( (0.1808 * plato(gravityPoints(og))) + (0.8192 * plato(gravityPoints(fg))) )

# IBU / ( gravityPoints(og) - gravityPoints(fg) )
hbmBitternessRatio = (bu, og, fg) ->
  bu / (gravityPoints(og) - gravityPoints(fg))

bitternessModel = () ->

  m =
    bu: ko.observable ""
    og: ko.observable ""
    fg: ko.observable ""

    obr: ko.observable ""
    rbr: ko.observable ""
    bure: ko.observable ""
    hbm: ko.observable ""
  m.calculateRatios = (m) ->
    bu = m.bu()
    og = m.og()
    fg = m.fg()

    originalRatio = originalBitternessRatio bu, og
    relativeRatio = relativeBitternessRatio originalRatio, og, fg
    bure = bitternessUnitsToRelativeRatio bu, og, fg
    hbm = hbmBitternessRatio bu, og, fg

    m.obr Math.round(originalRatio * 100) / 100
    m.rbr Math.round(relativeRatio * 100) / 100
    m.bure Math.round(bure * 100) / 100
    m.hbm Math.round(hbm * 100) / 100
  m

viewModel = () ->
  model = bitternessModel()
  model


$(document).ready(->
  ko.applyBindings new viewModel()
)
