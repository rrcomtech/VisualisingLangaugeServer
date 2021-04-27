package org.xtext.example.mydsl.ide.diagram.flexdr.elements

import org.eclipse.sprotty.SNode
import org.eclipse.sprotty.LayoutOptions
import org.eclipse.sprotty.SPort
import org.eclipse.sprotty.SLabel
import org.eclipse.sprotty.xtext.IDiagramGenerator.Context
import org.eclipse.emf.ecore.EObject
import org.xtext.example.mydsl.ide.diagram.flexdr.MetaModelClass
import org.xtext.example.mydsl.ide.diagram.launch.GraphicalServerLauncher

class StructuralElement extends SNode {
	
	public SPort port
	public SLabel label
	
	// Tracing is ignored for the moment.
	new(String label, String type, Context context) {
		super()

		this.setType(type.toLowerCase())
		
		val objId = label + "." + type
		
		this.id = context.idCache.uniqueId(objId)
		this.layout = "stack"
		
		this.layoutOptions = new LayoutOptions [
			paddingTop = 10.0
			paddingBottom = 10.0
			paddingLeft = 10.0
			paddingRight = 10.0
		]
		
		this.label = new SLabel [
			id = context.idCache.uniqueId(objId + ".label")
			text = label
		]
		
		this.port = new SPort [
			id = context.idCache.uniqueId(objId + ".port")
		]
		
		this.children = #[ this.label, this.port ]
		
	}
	
}