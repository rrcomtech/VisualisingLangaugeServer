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
import org.xtext.example.mydsl.ide.diagram.flexdr.MetaModelClass.Binding
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

class DiagramGenerator implements IDiagramGenerator {
	
	@Inject extension ITraceProvider
	@Inject extension SIssueMarkerDecorator
	

	String LABEL_ATTRIBUTE_NAME = "label";
	List<Binding> bindings;
	
	new() {
		// Get bindings set up by user.
		var bindingSetup = new BindingsSetup()
		bindings = bindingSetup.bindings
	}
	
	/**
	 * @returns SModelRoot
	 */
	override generate(Context context) {
		
		var model = context.resource.contents.head
				
		var graph = new SGraph()
		var root = new StructuralElement("Issue", "node", context, null, this)
		
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
		val label = getLabel(obj)
		
		var StructuralElement node;		
		if (label instanceof String) {
			node = new StructuralElement(label, binding.structuralClass.toString(), context, obj, this)
			diagramElements.add(node)
			
			// If relationship binding is set, connect to parent element.
			if (binding.connectionClass !== null) {
				diagramElements.add(new ConnectionElement("", binding.connectionClass.toString(), obj, context, parent, node.port, this))
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
			val bindingClassName = binding.astObjectClassName
			if (className.equals(bindingClassName)) return binding
		}
		return null
	}
	
	/**
	 * Searches for the label value of a given EObject. If not found, returns null.
	 */
	def Object getLabel(EObject obj) {
		try {
			return AttributeManager.getProperty(obj, this.LABEL_ATTRIBUTE_NAME);			
		} catch (Exception e) {
			e.printStackTrace();
			// A label could not be retrieved.
			return "";
		}		
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
	
}