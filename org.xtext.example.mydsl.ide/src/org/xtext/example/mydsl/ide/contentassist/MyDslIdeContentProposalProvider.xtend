package org.xtext.example.mydsl.ide.contentassist

import com.google.inject.Inject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider
import org.eclipse.xtext.scoping.IScopeProvider
import org.xtext.example.mydsl.services.MyDslGrammarAccess
import org.xtext.example.mydsl.myDsl.MyDslPackage

class MyDslIdeContentProposalProvider extends IdeContentProposalProvider {

	@Inject extension MyDslGrammarAccess

	@Inject IScopeProvider scopeProvider

	override protected _createProposals(RuleCall ruleCall, ContentAssistContext context,
		IIdeContentProposalAcceptor acceptor) {

		// Considered Alternatives
		if (decisionRecordRule == ruleCall.rule && context.currentModel !== null) {
			
			acceptor.accept(proposalCreator.createSnippet('''Title: "How do we solve the problem XYZ?"

User story: "Ticket-123"

Summary: "Write your summary here"
				
Considered alternatives: 
"Write your 1st alternative here"
"Write your 2nd alternative here"
"Write your 3rd alternative here"
				
We chose alternative: "Write your 1st alternative here"
because: "HERE COMES YOUR RATIONALE"''', "Compact Template Complete", context), 0)
		}

		// Considered Alternatives
		if (alternativesRule == ruleCall.rule && context.currentModel !== null) {
			acceptor.accept(proposalCreator.createSnippet('''Considered alternatives: 
${1:alternatives}
${2:"Write your 2nd alternative here"}''', "Considered alternatives: 2 -- Compact", context), 0)
			acceptor.accept(proposalCreator.createSnippet('''Considered alternatives: 
"Write your 1st alternative here"
"Write your 2nd alternative here"
"Write your 3rd alternative here"''', "Considered alternatives: 3 -- Compact", context), 0)
		}

		// Summary		
		if (summaryRule == ruleCall.rule && context.currentModel !== null) {
			acceptor.accept(
				proposalCreator.createSnippet('''Summary: "Write your summary here"''', "Summary -- Simple", context),
				0)
		}

		// User Story		
		if (userStoryRule == ruleCall.rule && context.currentModel !== null) {
			acceptor.accept(
				proposalCreator.createSnippet('''User story: "Ticket-123"''', "Provide a ticket ID", context), 0)
		}

		// Title
		if (titleRule == ruleCall.rule && context.currentModel !== null) {
			acceptor.accept(
				proposalCreator.createSnippet('''Title: "How do we solve the problem XYZ?"''',
					"Title template -- Compact", context), 0)
		}

		// outcome
		if (outcomeRule == ruleCall.rule && context.currentModel !== null) {
			val scope = scopeProvider.getScope(context.currentModel, MyDslPackage.Literals.OUTCOME__SELECTED)
			acceptor.accept(proposalCreator.createSnippet('''We chose alternative:«scope.allElements.map[name.toString]»» 
''', "Decision outcome template -- Compact", context), 0)
		}

//		// chosenAlternative
//		if (chosenAlternativeRule == ruleCall.rule && context.currentModel !== null) {
//			acceptor.accept(proposalCreator.createSnippet('''""''', "Chosen alternative template -- Compact", context),
//				0)
//		}

		if (becauseRule == ruleCall.rule && context.currentModel !== null) {
//			val scope = scopeProvider.getScope(context.currentModel, MyDslPackage.Literals.OUTCOME__BECAUSE)
//			if (scope.allElements.get(0) === null) {
			acceptor.accept(
				proposalCreator.createSnippet('''because: "HERE COMES YOUR RATIONALE"''',
					"Rationale template -- Compact", context), 0)
//			}
		}

		if (rationaleRule == ruleCall.rule && context.currentModel !== null) {
			val scope = scopeProvider.getScope(context.currentModel, MyDslPackage.Literals.OUTCOME__BECAUSE)
			if (scope.allElements !== null) {
				acceptor.accept(
					proposalCreator.createSnippet('''"HERE COMES YOUR RATIONALE"''', "Rationale template -- Compact",
						context), 0)
			}
		}

		super._createProposals(ruleCall, context, acceptor)
	}

}
