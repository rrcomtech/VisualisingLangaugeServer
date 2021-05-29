package org.xtext.example.mydsl.ide.diagram.flexdr;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.xtext.example.mydsl.ide.diagram.launch.GraphicalServerLauncher;

/**
 * 
 * @author Robert Richter
 * @date 21st April 2021
 * @organization Brandenburgisch-Technische Universität Cottbus-Senftenberg
 * @chair Software-Systems Engineering
 * 
 * Elements are taken from FlexDRMetaModel. Each object gets assigned a special type,
 * which is translated to a representation in the frontend.
 * 
 */
public enum EMetaModelTypes {

	// Structural Elements
	DROBJECT,
	STATEMENT,
	DECISION_PROBLEM_OR_RESULT,
	DECISION_PROBLEM,
	DECISION_RESULT,
	DECISION_OPTION,
	
	// Connection Elements
	GENERIC_RELATIONSHIP,
	ARGUMENTATIVE_RELATIONSHIP,
	DERIVATIVE_RELATIONSHIP,
	CONSEQUENCE_RELATIONSHIP,
	OPTION_RELATIONSHIP,
	
	// Error found
	NULL;
	
	public static List<Binding> bindings;
	
	private static String NO_TYPE = "null";
	
	public static String getNoType() {
		return NO_TYPE;
	}
	
	public static String toString(EMetaModelTypes cl) {		
		switch(cl) {
		case DROBJECT:
			return "Drobject";
		case STATEMENT:
			return "Statement";
		case DECISION_PROBLEM_OR_RESULT:
			return "Decision_problem_or_result";
		case DECISION_PROBLEM:
			return "Decision_problem";
		case DECISION_RESULT:
			return "Decision_result";
		case DECISION_OPTION:
			return "Decision_option";
		case GENERIC_RELATIONSHIP:
			return "Generic_relationship";
		case ARGUMENTATIVE_RELATIONSHIP:
			return "Argumentative_relationship";
		case DERIVATIVE_RELATIONSHIP:
			return "Derivative_relationship";
		case CONSEQUENCE_RELATIONSHIP:
			return "Consequence_relationship";
		case OPTION_RELATIONSHIP:
			return "Option_relationship";
		default:
			return NO_TYPE;
		}		
	}
	
	public static EMetaModelTypes getMetaModelClass(String cl) {
		switch(cl) {
		case "Drobject":
			return DROBJECT;
		case "Statement":
			return STATEMENT;
		case "Decision_problem_or_result":
			return DECISION_PROBLEM_OR_RESULT;
		case "Decision_problem":
			return DECISION_PROBLEM;
		case "Decision_result":
			return DECISION_RESULT;
		case "Decision_option":
			return DECISION_OPTION;
		case "Generic_relationship":
			return GENERIC_RELATIONSHIP;
		case "Argumentative_relationship":
			return ARGUMENTATIVE_RELATIONSHIP;
		case "Derivative_relationship":
			return DERIVATIVE_RELATIONSHIP;
		case "Consequence_relationship":
			return CONSEQUENCE_RELATIONSHIP;
		case "Option_relationship":
			return OPTION_RELATIONSHIP;
		default:
			return NULL;
		}
	}
	
	/**
	 * Returns the name of property if the object has one the features above.
	 * Otherwise returns NULL.
	 * This is not to be changed!
	 * 
	 * @param obj
	 * @return
	 */
	public static String hasAnyProperty(EObject obj) {		
		EMetaModelTypes[] classes = EMetaModelTypes.values();
		for (int i = 0; i < classes.length; i++) {			
			EMetaModelTypes metaModelClass = classes[i];
			String metaModelClassName = metaModelClass.toString();
			if (AttributeManager.objectHasProperty(obj, metaModelClass.toString())) {
				return metaModelClassName;
			};
		}
		return NO_TYPE;		
	}	

	
	public boolean isStructural() {
		switch(this) {
		case DROBJECT:
			return true;
		case STATEMENT:
			return true;
		case DECISION_PROBLEM_OR_RESULT:
			return true;
		case DECISION_PROBLEM:
			return true;
		case DECISION_RESULT:
			return true;
		case DECISION_OPTION:
			return true;
		default:
			return false;
		}
	}
	
	public boolean isConnection() {
		return !isStructural();
	}
	
	public static class Binding {
		public final String classToBeBinded;
		public final EMetaModelTypes type;
		public Binding(String classToBeBinded, EMetaModelTypes type) {
			this.type = type;
			this.classToBeBinded = classToBeBinded;
		}
	}
	
}
