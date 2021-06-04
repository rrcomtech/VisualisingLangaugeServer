package org.xtext.example.mydsl.ide.diagram.flexdr

import org.eclipse.sprotty.xtext.IDiagramGenerator
import org.eclipse.sprotty.xtext.IDiagramGenerator.Context
import org.eclipse.sprotty.SModelElement
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.sprotty.SGraph
import java.util.ArrayList
import org.eclipse.sprotty.SNode
import org.eclipse.sprotty.SLabel
import org.xtext.example.mydsl.myDsl.impl.*
import org.xtext.example.mydsl.ide.diagram.flexdr.elements.StructuralElement
import org.xtext.example.mydsl.ide.diagram.flexdr.elements.ConnectionElement
import org.eclipse.sprotty.SPort
import org.eclipse.emf.common.util.EList
import org.xtext.example.mydsl.ide.diagram.launch.GraphicalServerLauncher
import org.eclipse.sprotty.xtext.tracing.ITraceProvider
import com.google.inject.Inject
import org.eclipse.sprotty.xtext.SIssueMarkerDecorator
import org.eclipse.emf.ecore.EStructuralFeature
import javax.xml.crypto.dsig.keyinfo.RetrievalMethod

class DiagramGenerator implements IDiagramGenerator {
	
	@Inject extension ITraceProvider
	@Inject extension SIssueMarkerDecorator
	
	
	public String LABEL_ATTRIBUTE_NAME = "name"
	// If attribute "name" does not exist, use label. 
	// Using the attribute label, make the node unmodifiable.
	public String LABEL_FALLBACK_ATTRIBUTE_NAME = "label"
	List<Binding> bindings
	
	new() {
		// Get bindings set up by user.
		bindings = (new BindingsSetup()).bindings
	}
	
	/**
	 * @returns SModelRoot
	 */
	override generate(Context context) {
		
		var model = context.resource.contents.head
				
		var graph = new SGraph()
		var root = new StructuralElement("Issue", false, "node", context, null, this)
		
		var children = new ArrayList<SModelElement>()
		children.add(root)
		children.addAll(translateAstToDiagram(model, context, root.port))
		graph.children = children
		return graph
	
	}
	
	/**
	 * Idea: Recursively parse each of the objects. Each objects is 
	 * an EObject, which is supposed to be translated into a diagram
	 * element.
	 * 
	 * The result of each recursive iteration is a list of diagram elements.
	 * 
	 */
	def List<SModelElement> translateAstToDiagram(EObject obj, Context context, SModelElement parent) {
			
		// Look up the binding.
		val binding = this.findBinding(obj)
		
		// Look up the child elements.
		val children = obj.eContents
		val diagramElements = new ArrayList<SModelElement>()
		
		// Test if representation is desired.
		if (binding === null) {			
			// Recursively finds representations for child elements.
			for (child : children) {
				diagramElements.addAll(translateAstToDiagram(child, context, parent))
			}
			return diagramElements
		}
						
		// Create Node for currect object 
		val retrievedAttribute = getLabel(obj)
		val label = retrievedAttribute.label
		val modifiable = retrievedAttribute.modifiable
		
		var StructuralElement node;		
		
		/*
		 * A label can either be a text, or an AST-Object. 
		 * In case it is a text, this simply can be used as the caption of the node.
		 * If it is an AST-Object, this object will become the object to be translated.
		 */
		if (label instanceof String) {
			
			// The object is a node.
			if (binding.type.isStructural()) {
				node = new StructuralElement(label, modifiable, binding.type.toString(), context, obj, this)
				diagramElements.add(node)
			}
			// The object is an edge.
			if (binding.type.isConnection()) {
				val edge = new ConnectionElement("", binding.type.toString(), obj, context, parent, node.port, this)
				diagramElements.add(edge)
			}
			
		} else {
			if (label !== null) {
				if (label instanceof EObject) {
					diagramElements.addAll(translateAstToDiagram(label, context, parent))
				}
			}
		}
		
		for (child : children) {
			// The current object becomes the parent object.
			diagramElements.addAll(translateAstToDiagram(child, context, node))
		}
		
		return diagramElements 
		
	}
	
	/** 
	 * Looks up the bindings "dictionary" to find the binding for the given object.
	 */
	def Binding findBinding(EObject obj) {
		for (binding : this.bindings) {
			val className = obj.class.simpleName
			val bindingClassName = binding.classToBeBinded
			if (className.equals(bindingClassName)) return binding
		}
		return null
	}
	
	/**
	 * Searches for the label value of a given EObject. If not found, returns null.
	 */
	def RetrievedAttribute getLabel(EObject obj) {
		try {
			val label = AttributeManager.getProperty(obj, this.LABEL_ATTRIBUTE_NAME)
			return (new RetrievedAttribute(label, true))
		} catch (Exception e) {
			try {
				val label = AttributeManager.getProperty(obj, this.LABEL_FALLBACK_ATTRIBUTE_NAME)
				return (new RetrievedAttribute(label, false))
			} catch (Exception e2) {}			
		}
		// Both attributes for labels are not found.
		return null;
	}
	
	def <T extends SModelElement> T traceElement(T traceable, EObject source) {
		trace(traceable, source)
	}

	def <T extends SModelElement> T traceElement(T traceable, EObject source, EStructuralFeature feature, int index) {
		trace(traceable, source, feature, index)
	}
	
	
	def <T extends SModelElement> T traceAndMark(T sElement, EObject element, Context context) {
		sElement.trace(element).addIssueMarkers(element, context) 
	} 
	
	/**
	 * Helper class do determine both, a String and a flag if an AST-object is supposed to be modifiable.
	 */
	private static class RetrievedAttribute {
		boolean modifiable
		Object label
		new(Object label, boolean modifiable) {
			// The AST-object, which got the attribute "label". Not necessarily a String.
			this.label = label
			// The flag, which is process earlier.
			this.modifiable = modifiable
		}
	}
	
	
}