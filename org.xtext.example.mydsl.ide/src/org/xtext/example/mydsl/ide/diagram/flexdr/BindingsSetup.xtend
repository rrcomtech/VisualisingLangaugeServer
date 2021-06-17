package org.xtext.example.mydsl.ide.diagram.flexdr

import java.util.List
import java.util.ArrayList
import org.xtext.example.mydsl.myDsl.impl.*

class BindingsSetup {
	
	List<Binding> bindings
	
	new() {
		
		bindings = new ArrayList<Binding>()
		/*
		 * Binding have the style: 
		 * new Binding(TitleImpl.simpleName, EMetaModelTypes.STATEMENT),
		 * new Binding(LineImpl.simpleName, EMetaModelTypes.ARGUMENTATIVE_RELATIONSHIP),
		 * ...
		 * 
		 * To be concrete, there are three kinds of bindings. For detailed information, see
		 * Binding.xtend.
		 * 
		 */
		bindings.addAll(
			
			new Binding(TitleImpl.simpleName, EMetaModelTypes.STATEMENT),
			new Binding(SummaryImpl.simpleName, EMetaModelTypes.DECISION_PROBLEM),
			new Binding(EMetaModelTypes.OPTION_RELATIONSHIP, EMetaModelTypes.STATEMENT, EMetaModelTypes.STATEMENT),
			new Binding(EMetaModelTypes.CONSEQUENCE_RELATIONSHIP, EMetaModelTypes.STATEMENT, EMetaModelTypes.DECISION_PROBLEM)
			
		)
		
	}
	
	def getBindings() {
		return this.bindings
	}
	
}