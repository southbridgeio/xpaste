describe('metrics page', function() {
  it('displays metrics page correctly', function() {
    cy.request('/metrics').as('metrics')
    cy.get('@metrics').should((response) => {
      expect(response.body).include('# HELP')
      expect(response.body).include('# TYPE')
      expect(response.body).include('http_request_duration_seconds_bucket')
      expect(response.body).include('http_request_duration_seconds_count')
      expect(response.body).include('http_request_duration_seconds_sum')
      expect(response.body).include('http_requests_total')
      expect(response.body).include('process_virtual_memory_bytes')
    })
  })
})
