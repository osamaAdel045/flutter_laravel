import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/deployment_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/viewmodels/deployments_view_model.dart';
import 'package:flutter_laravel/core/viewmodels/servers_model.dart';
import 'package:flutter_laravel/ui/components/buttons/main_button.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'base_view.dart';

class DeploymentsView extends StatefulWidget {
  final Site? site;
  final Server? server;

  const DeploymentsView({Key? key, this.site, this.server}) : super(key: key);

  @override
  _DeploymentsViewState createState() => _DeploymentsViewState();
}

class _DeploymentsViewState extends State<DeploymentsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text(
          widget.server!.name!,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BaseView<DeploymentsViewModel>(
        onModelReady: (model) {
          return model.getDeployments((widget.server!.id!).toString(), (widget.site!.id!).toString());
        },
        builder: (context, model, child) => model.state == ViewState.Busy
            ? loadingIndicator()
            : ListView(
                children: List.generate(
                  model.deployments.length,
                  (i) => ServerCard(
                    context: context,
                    model: model,
                    deploymentModel: model.deployments[i],
                    site: widget.site,
                    server: widget.server,
                  ),
                ),
              ),
      ),
    );
  }
}

class ServerCard extends StatefulWidget {
  final Server? server;
  final Site? site;
  final BuildContext context;
  final DeploymentModel? deploymentModel;
  final DeploymentsViewModel? model;

  ServerCard({this.server,required this.context, this.site, this.model, this.deploymentModel});

  @override
  _ServerCardState createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ServerCardInfo(
                  'Server Name',
                  Text(
                    widget.server!.name!,
                    style: const TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  'Site Name',
                  Text(
                    widget.site!.name!,
                    style: const TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  'Commit Author',
                  Text(
                    widget.deploymentModel!.commit_author!,
                    style: const TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  'status',
                  Text(
                    widget.deploymentModel!.status!,
                    style: const TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  "Displayable type",
                  Text(
                    widget.deploymentModel!.displayable_type!,
                    style: const TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfoVertical(
                  'Commit message',
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.deploymentModel!.commit_message!,
                      style: const TextStyle(
                        color: Color(0Xff424c54),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                ServerCardInfoVertical(
                  "Commit hash",
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.deploymentModel!.commit_hash!,
                      style: const TextStyle(
                        color: Color(0Xff424c54),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                MainButton(
                  text: "Show Deployment Log",
                  margin: const EdgeInsets.all(5.0),
                  onPressed: () async{
                    String? log = await widget.model!.getDeploymentLog(widget.server!.id.toString(), widget.site!.id.toString(),(widget.deploymentModel!.id!).toString());
                    print("loglog");
                    print(log);
                    showDeploymentLog(widget.context, log);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget button(GestureTapCallback? onTap) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        color: Colors.green,
        elevation: 0,
        child: InkWell(
          hoverColor: Colors.green,
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Show Deployment Log',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  showDeploymentLog(BuildContext context, String? log) {
    TextEditingController controller = TextEditingController(text: log);
    final numLines = '\n'.allMatches(log!).length + 1;

    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff191B1C),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    color: Colors.white10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Text(
                            widget.site!.name!,
                          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        MainButton(
                          text: "Done",
                          onPressed: () => Navigator.of(context).pop(),
                          width: null,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: ListView.builder(
                                itemBuilder: (context, index) => Text(
                                  (index + 1).toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: numLines,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 9,
                            child: TextField(
                              autofocus: false,
                              readOnly: true,
                              controller: controller,
                              decoration: const InputDecoration(
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

class ServerCardInfo extends StatelessWidget {
  final String title;
  final Widget child;

  ServerCardInfo(this.title, this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Color(0Xff424c54),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Container()),
          child,
        ],
      ),
    );
  }
}

class ServerCardInfoVertical extends StatelessWidget {
  final String title;
  final Widget child;

  ServerCardInfoVertical(this.title, this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Color(0Xff424c54),
              fontWeight: FontWeight.bold,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
