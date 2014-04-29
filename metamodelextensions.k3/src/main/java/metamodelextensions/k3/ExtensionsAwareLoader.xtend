package metamodelextensions.k3

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.EPackage

interface ExtensionsAwareLoader
{
	def void     initialize(EPackage base, EPackage extended)

	def Resource loadExtendedAsBase(String uri, boolean loadOnDemand)
	def Resource loadBaseAsExtended(String uri, boolean loadOnDemand)
}
