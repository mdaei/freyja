#include "ADCarbonateChemistry.h"

registerMooseObject("freyjaApp", ADCarbonateChemistry);

InputParameters
ADCarbonateChemistry::validParams()
{
  InputParameters params = ADKernel::validParams();

  params.addRequiredCoupledVar("CO2",  "CO2 concentration");
  params.addRequiredCoupledVar("H",    "H+ concentration");
  params.addRequiredCoupledVar("HCO3", "HCO3- concentration");
  params.addRequiredCoupledVar("CO3",  "CO3^2- concentration");

  params.addRequiredParam<Real>("kf1", "Forward rate CO2 -> H + HCO3");
  params.addRequiredParam<Real>("kr1", "Reverse rate");
  params.addRequiredParam<Real>("kf2", "Forward rate HCO3 -> H + CO3");
  params.addRequiredParam<Real>("kr2", "Reverse rate");

  MooseEnum species("CO2 H HCO3 CO3");
  params.addRequiredParam<MooseEnum>("species", species,
                                     "Species this kernel acts on");

  return params;
}

ADCarbonateChemistry::ADCarbonateChemistry(const InputParameters & parameters)
  : ADKernel(parameters),
    _CO2(adCoupledValue("CO2")),
    _H(adCoupledValue("H")),
    _HCO3(adCoupledValue("HCO3")),
    _CO3(adCoupledValue("CO3")),
    _kf1(getParam<Real>("kf1")),
    _kr1(getParam<Real>("kr1")),
    _kf2(getParam<Real>("kf2")),
    _kr2(getParam<Real>("kr2")),
    _species(getParam<MooseEnum>("species"))
{
}

ADReal
ADCarbonateChemistry::computeQpResidual()
{
  // Reaction rates
  ADReal R1 = _kf1 * _CO2[_qp] - _kr1 * _H[_qp] * _HCO3[_qp];
  ADReal R2 = _kf2 * _HCO3[_qp] - _kr2 * _H[_qp] * _CO3[_qp];

  ADReal source = 0.0;

  if (_species == "CO2")
    source = -R1;
  else if (_species == "H")
    source = R1 + R2;
  else if (_species == "HCO3")
    source = R1 - R2;
  else if (_species == "CO3")
    source = R2;

  return _test[_i][_qp] * source;
}
