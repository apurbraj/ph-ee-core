package org.mifos.processor.bulk.camel.config;

public class CamelProperties {

    private CamelProperties() {}

    public static final String AUTH_TYPE = "authType";
    public static final String IS_BATCH_READY = "isBatchReady"; // camel property to check if batch is ready for sampling

    public static final String SERVER_FILE_NAME = "serverFileName";

    public static final String LOCAL_FILE_PATH = "localFilePath";

    public static final String SUB_BATCH_FILE_ARRAY = "subBatchFileArray";

    public static final String SUB_BATCH_COUNT = "subBatchCount";

    public static final String SUB_BATCH_CREATED = "subBatchCreated";

    public static final String SERVER_SUB_BATCH_FILE_NAME_ARRAY = "serverSubBatchFileName";

    public static final String TRANSACTION_LIST = "transactionList";

    public static final String OVERRIDE_HEADER = "overrideHeader";

    public static final String TENANT_NAME = "tenantName";

}
