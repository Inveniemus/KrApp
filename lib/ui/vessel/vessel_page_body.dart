import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/vessel/vessel_bloc.dart';

class VesselPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Center(child: Text('MANUAL REFRESH: '))),
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 30,
                ),
                onPressed: () =>
                    context.read<VesselBloc>().add(RequestVesselDataEvent()),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('Vessel name:'),
            BlocBuilder<VesselBloc, VesselState>(
              builder: (context, state) {
                print(state);
                if (state is VesselDataState) {
                  return Text(state.data.name);
                } else {
                  return Text('Unknown');
                }
              }
            ),
          ],
        )
      ],
    );
  }
}
