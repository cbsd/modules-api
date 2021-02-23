# api
CBSD module serving API service

This module requires the beanstalkd, cbsd-mq-router and cbsd-mq-api, please install first, e.g:

  `pkg install -y beanstalkd cbsd-mq-router cbsd-mq-api`

To install module:

  - echo 'api.d' >> ~cbsd/etc/modules.conf
  - cbsd initenv

Quick start:

  `service beanstalkd enable`
  `service cbsd-mq-router enable`
  `service cbsd-mq-api enable`

  `service beanstalkd start`
  `service cbsd-mq-router start`
  `service cbsd-mq-api start`

  Refer to the documentation page: https://www.bsdstore.ru/en/13.x/wf_api_ssi.html
