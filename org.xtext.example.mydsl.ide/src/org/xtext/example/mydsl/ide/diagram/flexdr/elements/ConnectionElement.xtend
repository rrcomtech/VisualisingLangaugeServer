package org.xtext.example.mydsl.ide.diagram.flexdr.elements

import org.eclipse.sprotty.SEdge
import org.eclipse.emf.ecore.EObject
import org.eclipse.sprotty.xtext.IDiagramGenerator.Context
import org.eclipse.sprotty.SModelElement
import org.xtext.example.mydsl.ide.diagram.flexdr.MetaModelClass
import org.xtext.example.mydsl.ide.diagram.launch.GraphicalServerLauncher

class ConnectionElement extends SEdge {
	
	new(String label, String type, 
		EObject astObject, Context context, 
		SModelElement source, SModelElement target
	){
		super()

		this.setType(type.toLowerCase())
		
		this.id = context.idCache.uniqueId(label + "." + type)
		this.sourceId = source.id
		this.targetId = target.id
	}
	
}