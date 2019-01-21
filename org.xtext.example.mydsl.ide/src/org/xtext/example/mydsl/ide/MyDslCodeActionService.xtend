package org.xtext.example.mydsl.ide

import org.eclipse.emf.common.util.URI
import org.eclipse.lsp4j.CodeAction
import org.eclipse.lsp4j.CodeActionKind
import org.eclipse.lsp4j.CodeActionParams
import org.eclipse.lsp4j.TextEdit
import org.eclipse.lsp4j.WorkspaceEdit
import org.eclipse.lsp4j.jsonrpc.messages.Either
import org.eclipse.xtext.ide.server.Document
import org.eclipse.xtext.ide.server.codeActions.ICodeActionService
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator
import org.xtext.example.mydsl.validation.MyDslValidator

class MyDslCodeActionService implements ICodeActionService {
	
	override getCodeActions(Document document, XtextResource resource, CodeActionParams params, CancelIndicator indicator) {
		val result = <CodeAction>newArrayList
		for (d : params.context.diagnostics) {
			if (d.code == MyDslValidator.INVALID_NAME
			) {
				val text = document.getSubstring(d.range)
				result += new CodeAction => [
					kind = CodeActionKind.QuickFix
					title = "Capitalize Name"
					diagnostics = #[d]
					// for more complex example we would use 
					// change serializer as in RenameService
					edit = new WorkspaceEdit() => [
						addTextEdit(resource.URI, new TextEdit=> [
							range = d.range
							newText = text.toFirstUpper
						])
					]
					
				]
							
			}
}
		return result.map[Either.forRight(it)]
	}
	
	protected def addTextEdit(WorkspaceEdit edit, URI uri, TextEdit... textEdit) {
		edit.changes.put(uri.toString, textEdit)
	}
	
}