# Конфигурация

В рамках kubernetes, наиболеее удобный способ хранения конфигурации - ресурс ConfigMap.

Преимущества:
- различные типы данных: из файла / json / yaml / toml
Опции генерации и форматирования configmap: https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-a-configmap-using-kubectl-create-configmap
- можно монтировать файлом в контейнер
```
volumeMounts:
    - mountPath: /etc/configmap
    name: conf-mount
nodeName: l2-cluster-master
volumes:
- name: conf-mount
    configMap:
        name: testconf
```
- можно подтаскивать поля в аргументы для entrypoint контейнера или в качестве переменных среды на уровне kubernetes манифеста

ENV:
```
env:
# Define the environment variable
- name: SPECIAL_LEVEL_KEY
    valueFrom:
    configMapKeyRef:
        # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
        name: special-config
        # Specify the key associated with the value
        key: special.how
```
ENV + CMD:
```
command: [ "/bin/sh", "-c", "echo $(SPECIAL_LEVEL_KEY) $(SPECIAL_TYPE_KEY)" ]
      env:
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              name: special-config
              key: SPECIAL_LEVEL
        - name: SPECIAL_TYPE_KEY
          valueFrom:
            configMapKeyRef:
              name: special-config
              key: SPECIAL_TYPE
```
- конфигурация в поде синхронизируется с configmap ресурсом в кластере, но только в случае монтирования configmap файлом. В случае с передачей значений в виде перменных среды, под необходимо перезагрузить для применения изменений.

- ConfigMap ресурсы удобно менять в kubernetes dashboard. Через ~ 15 секунд после изменения ресурса, изменения применяются в поде