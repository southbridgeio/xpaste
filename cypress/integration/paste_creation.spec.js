describe('paste creation', function() {
  let paste_text = 'test'

  beforeEach(()=> cy.visit('/'))

  it('creates paste', function() {
    cy.get('textarea#paste_body').type(paste_text)
    cy.contains('Создать').click()
    cy.get('pre.code').should('contain', paste_text)
  })

  context('when password tab chosen', function(){
    beforeEach(()=> cy.contains('Пароль').click())

    it('checks auto destroy checkbox', function() {
      cy.get('input[name=auto_destroy]').should('be.checked')
    })

    it('creates self-destroying paste on submit', function() {
      cy.get('textarea#paste_body').type(paste_text)
      cy.contains('Создать').click()
      cy.get('body').should('contain', 'После просмотра заметка будет удалена')
    })
  })
})
