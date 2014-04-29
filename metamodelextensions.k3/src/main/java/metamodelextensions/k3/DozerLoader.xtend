package metamodelextensions.k3

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl

class DozerLoader implements ExtensionsAwareLoader
{
	override initialize(EPackage base, EPackage extended) {
		// Regular EMF Registration
		Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(fsm.FsmPackage.eNS_PREFIX,   new XMIResourceFactoryImpl)
		Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(tfsm.TfsmPackage.eNS_PREFIX, new XMIResourceFactoryImpl)

		EPackage$Registry.INSTANCE.put(fsm.FsmPackage.eNS_URI,   fsm.FsmPackage.eINSTANCE)
		EPackage$Registry.INSTANCE.put(tfsm.TfsmPackage.eNS_URI, tfsm.TfsmPackage.eINSTANCE)
	}

	override loadExtendedAsBase(String uri, boolean loadOnDemand) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override loadBaseAsExtended(String uri, boolean loadOnDemand) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
