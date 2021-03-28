header.header.header-inverse.overflow-hidden.orange-header
  .container.text-center
    .row
      .col-12.col-lg-8.offset-lg-2
        h1
          | Внутренняя ошибка сервера
        p.fs-20.opacity-80
          | Упс, случилось что-то непредвиденное.
          br
          - if @development
            pre.backtrace = @ex.inspect_with_backtrace