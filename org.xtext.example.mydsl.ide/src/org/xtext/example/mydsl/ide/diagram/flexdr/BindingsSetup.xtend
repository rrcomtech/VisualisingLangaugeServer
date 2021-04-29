package org.xtext.example.mydsl.ide.diagram.flexdr

import java.util.List
import org.xtext.example.mydsl.ide.diagram.flexdr.MetaModelClass.Binding
import java.util.ArrayList
import org.xtext.example.mydsl.myDsl.impl.*

class BindingsSetup {
	
	private List<Binding> bindings
	
	new() {
		
		bindings = new ArrayList<Binding>()
		
		bindings.addAll(
			
			new Binding(TitleImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.ARGUMENTATIVE_RELATIONSHIP),
			new Binding(UserStoryImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.ARGUMENTATIVE_RELATIONSHIP),
			new Binding(SummaryImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.ARGUMENTATIVE_RELATIONSHIP),
			new Binding(AlternativesImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.ARGUMENTATIVE_RELATIONSHIP),
			new Binding(AlternativeImpl.simpleName, MetaModelClass.DECISION_OPTION, MetaModelClass.OPTION_RELATIONSHIP),
			new Binding(OutcomeImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.ARGUMENTATIVE_RELATIONSHIP),
			new Binding(BecauseImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.ARGUMENTATIVE_RELATIONSHIP),	
			new Binding(ChosenAlternativeImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.CONSEQUENCE_RELATIONSHIP),
			new Binding(RationaleImpl.simpleName, MetaModelClass.STATEMENT, MetaModelClass.ARGUMENTATIVE_RELATIONSHIP)
			
		)
		
	}
	
	def getBindings() {
		return this.bindings
	}
	
}