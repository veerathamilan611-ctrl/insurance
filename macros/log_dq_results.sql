{% macro log_dq_results(results) %}

    {% if execute %}

        {% for result in results %}

            {% if result.node.resource_type == "test" %}

                {% set rule_id = result.node.config.meta.get("dq_rule_id") %}

                {% if rule_id %}

                    {% set failed_count = (
                        result.failures if result.failures is not none else 0
                    ) %}

                    {% set test_status = result.status | upper %}

                    {% set model_name = result.node.name %}

                    {% set run_id = invocation_id %}

                    {% set insert_sql %}
                        INSERT INTO INSURANCE_DB_SATYASUDAR.AUDIT.DQ_LOG
                        (
                            RUN_ID,
                            RULE_ID,
                            MODEL_NAME,
                            FAILED_ROW_COUNT,
                            TEST_STATUS,
                            LOGGED_AT
                        )
                        VALUES (
                            '{{ run_id }}',
                            '{{ rule_id }}',
                            '{{ model_name }}',
                            {{ failed_count }},
                            '{{ test_status }}',
                            CURRENT_TIMESTAMP()
                        )
                    {% endset %}

                    {% do run_query(insert_sql) %}

                {% endif %}

            {% endif %}

        {% endfor %}

    {% endif %}

{% endmacro %}
