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

	override loadExtendedAsBase(String uri, boolean loadOnDemand) throws PackageCompatibilityError {
		val res = loadModel(uri, loadOnDemand) // Just propagate thrown exceptions if any
		val root = res.contents.head

		// Ensure that model @uri conforms to the extended metamodel
		if (root.eClass.EPackage != pkgExtended)
			throw new PackageCompatibilityError('''«uri» doesn't conform to the extended metamodel''')

		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override loadBaseAsExtended(String uri, boolean loadOnDemand) {
		val res = loadModel(uri, loadOnDemand) // Just propagate thrown exceptions if any
		val root = res.contents.head

		// Ensure that model @uri conforms to the extended metamodel
		if (root.eClass.EPackage != pkgBase)
			throw new PackageCompatibilityError('''«uri» doesn't conform to the extended metamodel''')

		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	private def loadModel(String uri, boolean loadOnDemand) {
		val rs = new ResourceSetImpl
		val res = rs.getResource(URI.createURI(uri), loadOnDemand)

		return res
	}
}
