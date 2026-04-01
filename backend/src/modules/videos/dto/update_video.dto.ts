import { PartialType } from "@nestjs/mapped-types";
import { CreateVideoDto } from "./create_video.dto";

export class UpdateVideoDto extends PartialType(CreateVideoDto) {}
