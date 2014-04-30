package metamodelextensions.k3

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.URI

class DozerLoader implements ExtensionsAwareLoader
{
	private EPackage pkgBase
	private EPackage pkgExtended

	override initialize(EPackage base, EPackage extended) {
		pkgBase = base
		pkgExtended = extended

		// Regular EMF Registration
		Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(base.nsPrefix,     new XMIResourceFactoryImpl)
		Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(extended.nsPrefix, new XMIResourceFactoryImpl)

		EPackage$Registry.INSTANCE.put(base.nsURI,     base)
		EPackage$Registry.INSTANCE.put(extended.nsURI, extended)
	}

	override loadExtendedAsBase(String uri, boolean loadOnDemand) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override loadBaseAsExtended(String uri, boolean loadOnDemand) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
