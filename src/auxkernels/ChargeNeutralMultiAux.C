#include "ChargeNeutralMultiAux.h"

registerMooseObject("freyjaApp", ChargeNeutralMultiAux);

InputParameters
ChargeNeutralMultiAux::validParams()
{
  InputParameters params = AuxKernel::validParams();

  params.addRequiredCoupledVar("species", "List of species in neutrality sum");
  params.addRequiredParam<std::vector<Real>>("charges", "Charges of species");
  params.addRequiredParam<Real>("z_target", "Charge of eliminated species");

  return params;
}

ChargeNeutralMultiAux::ChargeNeutralMultiAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _species(coupledValues("species")),
    _charges(getParam<std::vector<Real>>("charges")),
    _z_target(getParam<Real>("z_target"))
{
}

Real
ChargeNeutralMultiAux::computeValue()
{
  Real sum = 0.0;

  for (unsigned int i = 0; i < _species.size(); ++i)
    sum += _charges[i] * (*_species[i])[_qp];

  return -sum / _z_target;
}
