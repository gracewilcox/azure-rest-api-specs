import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using TypeSpec.Http;
using TypeSpec.Versioning;

@versioned(LogsIngestion.Versions)
namespace ClientCustomizations;

@@clientName(LogsIngestion, "Client", "go");

using LogsIngestion;

@@access(upload, Access.internal, "python");

// go configuration- using override to remove optional parameter `ClientRequestIdHeader`

/**
 * Ingestion API used to directly ingest data using Data Collection Rules.
 */
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@summary("Ingestion API used to directly ingest data using Data Collection Rules.")
@route("/dataCollectionRules/{ruleId}/streams/{stream}")
@post
op upload2 is Azure.Core.Foundations.Operation<
  {
    @doc("The immutable ID of the Data Collection Rule resource.")
    @path
    ruleId: string;

    @doc("The streamDeclaration name as defined in the Data Collection Rule.")
    @clientName("streamName")
    @path
    stream: string;

    @doc("The content encoding of the request body which is always 'gzip'.")
    @header("Content-Encoding")
    contentEncoding?: string;

    #suppress "@azure-tools/typespec-azure-core/request-body-problem"
    @doc("The array of objects matching the schema defined by the provided stream.")
    @alternateType(unknown, "go")
    @clientName("logs", "go")
    @body
    body: Record<unknown>[];
  },
  void
>;

@@override(upload, upload2, "go");

