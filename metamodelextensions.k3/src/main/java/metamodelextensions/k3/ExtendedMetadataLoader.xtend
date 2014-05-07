package metamodelextensions.k3

import org.eclipse.emf.common.util.URI

import org.eclipse.emf.ecore.EPackage

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceFactoryImpl
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

import org.eclipse.emf.ecore.util.BasicExtendedMetaData

import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl
import org.eclipse.emf.ecore.xmi.XMIResource

class ExtendedMetadataLoader implements ExtensionsAwareLoader
{
	private EPackage pkgBase
	private EPackage pkgExtended

	override initialize(EPackage base, EPackage extended) {
		pkgBase = base
		pkgExtended = extended

		// Regular EMF Registration
		//Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(base.nsPrefix,     new XMIResourceFactoryImpl)
		//Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(extended.nsPrefix, new XMIResourceFactoryImpl)
		Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(base.nsPrefix,     new ExtensionsAwareResourceFactoryImpl)
		Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.put(extended.nsPrefix, new ExtensionsAwareResourceFactoryImpl)

		EPackage$Registry.INSTANCE.put(base.nsURI,     base)
		EPackage$Registry.INSTANCE.put(extended.nsURI, extended)
	}

	override loadExtendedAsBase(String uri, boolean loadOnDemand) {
		val rs = new ResourceSetImpl
		val res = rs.getResource(URI.createURI(uri), loadOnDemand)

		return res
	}

	override loadBaseAsExtended(String uri, boolean loadOnDemand) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}

// FIXME: Make me generic
class ExtensionsAwareMetadata extends BasicExtendedMetaData
{
	override getPackage(String namespace) {
		val x = if (namespace == tfsm.TfsmPackage.eNS_URI)
			fsm.FsmPackage.eINSTANCE
		else if (namespace == fsm.FsmPackage.eNS_URI)
			tfsm.TfsmPackage.eINSTANCE
		else
			super.getPackage(namespace)

		return x
	}

	override getType(EPackage pkg, String name) {
		super.getType(pkg, name)
	}
}

class ExtensionsAwareResourceFactoryImpl extends ResourceFactoryImpl
{
	override createResource(URI uri) {
		val res = new XMIResourceImpl(uri)

		res.defaultLoadOptions.put(XMIResource.OPTION_EXTENDED_META_DATA, new ExtensionsAwareMetadata)
		res.defaultLoadOptions.put(XMIResource.OPTION_RECORD_UNKNOWN_FEATURE, Boolean.TRUE)

		return res
	}
}
