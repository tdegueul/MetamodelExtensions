package metamodelextensions.k3.tests

import metamodelextensions.k3.DozerLoader

class DozerStrategyTest extends CommonTest
{
	override setUp() {
		loader = new DozerLoader
		loader.initialize(fsm.FsmPackage.eINSTANCE, tfsm.TfsmPackage.eINSTANCE)
	}
}
