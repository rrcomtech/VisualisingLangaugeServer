package org.xtext.example.mydsl.ide.diagram.flexdr

import java.util.List
import org.xtext.example.mydsl.ide.diagram.flexdr.EMetaModelTypes.Binding
import java.util.ArrayList
import org.xtext.example.mydsl.myDsl.impl.*

class BindingsSetup {
	
	private List<Binding> bindings
	
	new() {
		
		bindings = new ArrayList<Binding>()
		
		bindings.addAll(
			/*
			 * Binding have the style: 
			 * new Binding(TitleImpl.simpleName, EMetaModelTypes.STATEMENT),
			 * new Binding(LineImpl.simpleName, EMetaModelTypes.ARGUMENTATIVE_RELATIONSHIP),
			 * ...
			 */
			
		)
		
	}
	
	def getBindings() {
		return this.bindings
	}
	
}