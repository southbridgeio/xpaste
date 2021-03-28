describe('main page', function() {
  it('displays main page correctly', function() {
    cy.visit('/')
    cy.get('body').should('contain', 'Упакуем пароль или код в cсылку для передачи')
  })
})
