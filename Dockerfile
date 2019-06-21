FROM hashicorp/terraform:0.11.11

LABEL version="1.0.0"
LABEL name="terraform-deploy-action"

LABEL "com.github.actions.name"="terraform-deploy-action"
LABEL "com.github.actions.description"="Deploy terraform action"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="red"

RUN apk --no-cache add jq

ENV PATH="/usr/local/bin:${PATH}"
COPY bin /usr/local/bin

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
