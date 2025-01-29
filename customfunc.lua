--ターゲットから見た自分のヨーを取得する
function GetTargetToSelfYaw( context )
	local Yaw = -180;
	while (SelfIsInTargetPartialSphere( context, 90, -90, Yaw, Yaw + 1) == false) do --関数の結果がtrueのときwhile実行
			Yaw = Yaw + 1;
	end
	return Yaw; --Yawを取得した
end

--自分から見たターゲットのヨーを取得する
function GetSelfToTargetYaw( context )
	local Yaw = -180;
	while (IsInTargetPartialSphere( context, 90, -90, Yaw, Yaw + 1) == false) do --関数の結果がtrueのときwhile実行
			Yaw = Yaw + 1;
	end
	return Yaw; --Yawを取得した
end

--自分から見たターゲットのピッチを取得する
function GetSelfToTargetPitch( context )
	local Pitch = -90;
	while (IsInTargetPartialSphere( context, Pitch, Pitch + 1, -180, 180) == false) do --関数の結果がtrueのときwhile実行
			Pitch = Pitch + 1;
	end
	return Pitch; --Pitchを取得した
end

--ターゲットの未来位置を取得する
function GetPredictTargetPosition( context, prevYaw, Yaw, PREV_distxz, distxz )
	
end

--自分の下の地面自体の絶対高度を取得する
function GetGroundAltitude( context )
	local Alt_E = GetEntityAltitude( context, 0); --プレイヤーの絶対高度を取得する
	local Alt_R = GetToTargetAltitude( context ); --自機とプレイヤーの相対高度を取得する
	local Alt_G = GetAltitudeGroundRelation( context ); --自機と地面の距離を取得する
	local Alt = Alt_E - Alt_R -Alt_G;
	return Alt;
end

--通常QTを利用可能にする(QT反応角が0の場合に有効) 
function SetEnableNomalQT( context, nowYaw, minYaw, maxYaw ) 
	if ( nowYaw < minYaw or nowYaw > maxYaw ) then
		SetEnableTurnToTarget( context, true );
		if (nowYaw <= 0) then
			return 2; --左向きQTを利用した(右側扱い)
		else
			return 3; --右向きQTを利用した(左側扱い)
		end
	else
		SetEnableTurnToTarget( context, false );
		return 1; --QTを利用しなかった
	end
end

--予測QTを利用可能にする(QT反応角が0の場合に有効) QT旋回中は発動しない minYaw~maxYaw内でQT発動
function SetEnablePredictQT( context, prevYaw, nowYaw, minYaw, maxYaw ) --Yaw*2<<実際のQT旋回角が理想。LAHIRE脚の場合は30°以内が良い
	if (QT_counter < 30) then
		SetEnableTurnToTarget( context, false );
		QT_counter = QT_counter + 1;
		return 1; --QTを利用しなかった
	elseif (nowYaw <= maxYaw and nowYaw >= minYaw and QT_counter >= 30) then
		SetEnableTurnToTarget( context, true );
		QT_counter = 0;
		if (nowYaw <= 0) then
			return 2; --左向きQTを利用した(右側扱い)
		else
			return 3; --右向きQTを利用した(左側扱い)
		end
	end
end
