package metamodelextensions.k3.tests

import metamodelextensions.k3.ExtensionsAwareLoader
import metamodelextensions.k3.PackageCompatibilityError

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource

import static org.junit.Assert.*

import org.junit.Before
import org.junit.Test

abstract class CommonTest
{
	protected ExtensionsAwareLoader loader
	protected static final String FSM_INPUT  = "inputs/Simple.fsm"
	protected static final String TFSM_INPUT = "inputs/Simple.tfsm"
	
	// Subclasses need to initialize the loader with the appropriate strategy
	@Before
	def void setUp()
	
	@Test
	def testRegistration() {
		assertTrue(EPackage$Registry.INSTANCE.containsKey(fsm.FsmPackage.eNS_URI))
		assertTrue(EPackage$Registry.INSTANCE.containsKey(tfsm.TfsmPackage.eNS_URI))
		assertTrue(Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.containsKey(fsm.FsmPackage.eNS_PREFIX))
		assertTrue(Resource$Factory$Registry.INSTANCE.extensionToFactoryMap.containsKey(tfsm.TfsmPackage.eNS_PREFIX))
	}

	@Test
	def testLoadExtendedAsBase() {
		val res = loader.loadExtendedAsBase(TFSM_INPUT, true)
		assertNotNull(res)

		// We loaded a Tfsm-conforming model and now we expect a fsm-conforming one
		assertTrue(res.contents.head instanceof fsm.FSM)
		val root = res.contents.head as fsm.FSM

		// Checking type correctness
		assertTrue(root.ownedState.forall[!(it instanceof tfsm.State)])
		assertTrue(root.ownedState.forall[it.outgoingTransition.forall[!(it instanceof tfsm.Transition)]])

		// Common features should have been preserved
		assertEquals(3, root.ownedState.size)
		assertEquals(2, root.ownedState.map[outgoingTransition].flatten.size)

		val s11 = root.ownedState.get(0)
		val s22 = root.ownedState.get(1)
		val s33 = root.ownedState.get(2)
		val t11 = root.ownedState.get(0).outgoingTransition.get(0)
		val t22 = root.ownedState.get(1).outgoingTransition.get(0)

		assertEquals(3, root.ownedState.size)
		assertEquals(3, root.ownedState.map[outgoingTransition].flatten.size)
		assertEquals("s11", s11.name)
		assertEquals("s22", s22.name)
		assertEquals("s33", s33.name)
		assertEquals("i11", t11.input)
		assertEquals("o11", t11.output)
		assertEquals(s11,   t11.source)
		assertEquals(s22,   t11.target)
		assertEquals("i22", t22.input)
		assertEquals("o22", t22.output)
		assertEquals(s22,   t22.source)
		assertEquals(s33,   t22.target)
	}

	@Test(expected = PackageCompatibilityError)
	def void testLoadIncorrectExtendedAsBase() {
		// Trying to use Fsm as extended metamodel should raise an exception
		loader.loadExtendedAsBase(FSM_INPUT, true)
	}

	@Test
	def testLoadBaseAsExtended() {
		val res = loader.loadBaseAsExtended(FSM_INPUT, true)
		assertNotNull(res)

		// We loaded a Fsm-conforming model and now we expect a Tfsm-conforming one
		assertTrue(res.contents.head instanceof tfsm.FSM)
		val root = res.contents.head as tfsm.FSM

		// Checking type correctness
		assertTrue(root.ownedState.forall[it instanceof tfsm.State])
		assertTrue(root.ownedState.forall[it.outgoingTransition.forall[it instanceof tfsm.Transition]])

		// Previous features should have been preserved
		assertEquals(3, root.ownedState.size)
		assertEquals(2, root.ownedState.map[outgoingTransition].flatten.size)

		val s1 = root.ownedState.get(0)
		val s2 = root.ownedState.get(1)
		val s3 = root.ownedState.get(2)
		val t1 = root.ownedState.get(0).outgoingTransition.get(0)
		val t2 = root.ownedState.get(1).outgoingTransition.get(0)

		assertEquals("s1", s1.name)
		assertEquals("s2", s2.name)
		assertEquals("s3", s3.name)
		assertEquals("i1", t1.input)
		assertEquals("o1", t1.output)
		assertEquals(s1,   t1.source)
		assertEquals(s2,   t1.target)
		assertEquals("i2", t2.input)
		assertEquals("o2", t2.output)
		assertEquals(s2,   t2.source)
		assertEquals(s3,   t2.target)

		// Features added by the extension should be null
		assertNull(root.currentState)
		assertTrue(root.ownedState.map[outgoingTransition].flatten.filter(tfsm.Transition).forall[guard === null])
		assertTrue(root.ownedState.filter(tfsm.State).forall[time == 0])
	}

	@Test(expected = PackageCompatibilityError)
	def void testLoadIncorrectBaseAsExtended() {
		// Trying to use Tfsm as base metamodel should raise an exception
		loader.loadBaseAsExtended(TFSM_INPUT, true)
	}
}
