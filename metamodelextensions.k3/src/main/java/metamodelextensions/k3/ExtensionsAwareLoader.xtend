package metamodelextensions.k3

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.EPackage

interface ExtensionsAwareLoader
{
	def void     initialize(EPackage base, EPackage extended)

	def Resource loadExtendedAsBase(String uri, boolean loadOnDemand) throws PackageCompatibilityError
	def Resource loadBaseAsExtended(String uri, boolean loadOnDemand) throws PackageCompatibilityError
}

class PackageCompatibilityError extends Exception
{
	new(String msg) {
		super(msg)
	}
}
