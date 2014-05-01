package metamodelextensions.k3

import org.eclipse.emf.ecore.EClassifier

class EcoreHelper
{
	// FIXME: How ugly is that!
	static def getImplementationClass(EClassifier cls) {
		val clsInterface = cls.instanceClass

		return Class.forName('''«clsInterface.package.name».impl.«clsInterface.simpleName»Impl''')
	}
}
