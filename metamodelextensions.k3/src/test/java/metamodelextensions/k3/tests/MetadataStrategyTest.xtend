package metamodelextensions.k3.tests

import metamodelextensions.k3.ExtendedMetadataLoader

class MetadataStrategyTest extends CommonTest
{
	override setUp() {
		loader = new ExtendedMetadataLoader
		loader.initialize(fsm.FsmPackage.eINSTANCE, tfsm.TfsmPackage.eINSTANCE)
	}
}
